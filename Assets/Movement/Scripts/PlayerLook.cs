using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerLook : MonoBehaviour
{

    [SerializeField] private float sensX;
    [SerializeField] private float sensY;


    Camera cam;

    float mouseX;
    float mouseY;

    float multiplier = 0.01f;

    float xRotation = 0;
    float yRotation = 0;

    [SerializeField]
    private GameObject parent2;

    [SerializeField]
    public bool overrideEnabled;
    [SerializeField]
    private Transform overrideLocationDirection;
    private Vector3 pOverridePos;
    private Quaternion pOverrideRot;

    // Start is called before the first frame update
    void Start()
    {
        cam = GetComponentInChildren<Camera>();
        if (cam == null)
        {
            cam = GameObject.FindGameObjectWithTag("MainCamera").GetComponent<Camera>();
        }

        // Lock cursor
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
        
    }

    // Update is called once per frame
    void Update()
    {
        if (!overrideEnabled)
        {
            HandleInput();

            //cam.transform.localRotation = Quaternion.Euler(xRotation, 0, 0);
            parent2.transform.localRotation = Quaternion.Euler(xRotation, 0, 0);

            // only want player to rotate on y axis
            transform.rotation = Quaternion.Euler(0, yRotation, 0);
        }
        else
        {
            this.cam.transform.position = Vector3.MoveTowards(this.cam.transform.position,this.overrideLocationDirection.gameObject.transform.position,Time.deltaTime*5f);
            this.cam.transform.rotation = Quaternion.RotateTowards(this.cam.transform.rotation, this.overrideLocationDirection.rotation, Time.deltaTime*180f);
        }

        if (Input.GetKeyDown(KeyCode.X))
        {
            if (this.overrideEnabled)
            {
                this.DisableOverride();

            }
            else
            {
                this.EnableOverride(overrideLocationDirection);
            }
        }
    }
    public void EnableSetOveride()
    {
        this.EnableOverride(overrideLocationDirection);
    }

    public void EnableOverride(Transform posdir)
    {
        pOverridePos = cam.transform.localPosition;
        pOverrideRot = cam.transform.localRotation;
        
        this.overrideEnabled = true;
        this.overrideLocationDirection = posdir;


    }
    public void DisableOverride()
    {
        this.overrideEnabled = false;
        this.cam.transform.localPosition = pOverridePos;
        this.cam.transform.localRotation = pOverrideRot;
        
        
    }

    void HandleInput()
    {
        // get the current mouse position
        mouseX = Input.GetAxisRaw("Mouse X");
        mouseY = Input.GetAxisRaw("Mouse Y");

        // when we rotate horizontally, we move on y axis
        yRotation += mouseX * sensX * multiplier;
        // moving on x makes camera look up and down
        xRotation -= mouseY * sensY * multiplier;

        // clamp so you cant look to far up or down
        xRotation = Mathf.Clamp(xRotation, -90f, 90f); 
    }
}
